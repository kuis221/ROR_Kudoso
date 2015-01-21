require 'rails_helper'

RSpec.describe Member, :type => :model do
  before(:each) do
    @member = FactoryGirl.create(:member)
  end

  it 'has a valid factory' do
    expect(@member.valid?).to be_truthy
    expect(@member.full_name).to eq("#{@member.first_name} #{@member.last_name}")
  end

  it 'should not allow duplicate usernames within a fmaily' do
    member_2 = Member.new(first_name: @member.first_name, username: @member.username, family_id: @member.family_id)
    expect(member_2.valid?).to be_falsey
    expect(member_2.errors[:username].any?).to be_truthy
  end

  it 'should return available screen time' do
    expect(@member.get_available_screen_time).to eq(60*60*24) # 24 hours in seconds

    @member.set_screen_time!(Date.today.wday, 3600)
    expect(@member.get_available_screen_time).to eq(3600)

    device = FactoryGirl.create(:device, family_id: @member.family.id )
    @member.set_screen_time!(Date.today.wday, 1800, device.id)
    expect(@member.get_available_screen_time).to eq(3600)
    expect(@member.get_available_screen_time(Date.today, device.id)).to eq(1800)
  end

  it 'should record activities as screen time' do
    device = FactoryGirl.create(:device, family_id: @member.family.id )
    start_time = @member.get_available_screen_time(Date.today, device.id)
    family_activity = FactoryGirl.create(:family_activity, family_id: @member.family.id, device_types: [device.device_type] )
    act = @member.new_activity(family_activity, device)
    act.start!
    sleep(3)
    act.stop!
    end_time = @member.get_available_screen_time(Date.today, device.id)
    used_time = @member.get_used_screen_time(Date.today, device.id)
    expect(used_time).to eq(act.duration)
    expect(used_time).to eq(start_time-end_time)
  end

  context 'with a month of todos' do

    before(:each) do
      @member = FactoryGirl.create(:member)
      template = FactoryGirl.create(:todo_template)
      @member.family.assign_template(template, [@member.id])


      #make schedule start in past
      @member.todo_schedules.find_each do |ts|
        ts.start_date = 31.days.ago.to_date
        ts.save!(validate: false)
      end

      (31.days.ago.to_date .. 1.days.ago.to_date).each { |d| Family.memorialize_todos(d) }
      expect(@member.my_todos.count).to eq(31)
    end

    it 'should return a months worth of my_todos when details are called' do
      @member.reload
      expect(@member.details.count).to be >= 28 #depends on the month the test is run
    end

    it 'should return todos for today or a date range' do
      todos = @member.todos #for today
      expect(todos.count).to eq(1)

      todos = @member.todos(Date.today, 3.days.from_now) #for today
      expect(todos.count).to eq(4)
    end

  end


end
