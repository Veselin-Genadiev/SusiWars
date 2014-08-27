require_relative 'spec_helper'

describe User do
  before :each do
    @user = User.user('User')
    @admin = User.admin('Admin')
    @bash_admin = User.bash_admin('Bash Admin')
  end

  it 'should be valid' do
    expect(@user).to be_valid
    expect(@admin).to be_valid
    expect(@bash_admin).to be_valid
  end

  it 'should change roles successfull' do
    expect(User.admin(@user.username).permission).to eq(:admin)
    expect(User.bash_admin(@user.username).permission).to eq(:bash_admin)
    expect(User.admin(@user.username).permission).to eq(:admin)
  end

  it 'should list all users' do
    @second_user = User.user('Second user')
    expect(User.users).to eq([@user, @second_user])
  end

  it 'should list all admins' do
    @second_admin = User.admin('Second admin')
    expect(User.admins).to eq([@admin, @second_admin])
  end

  it 'should list all bash admins' do
    @second_bash_admin = User.bash_admin('Second bash admin')
    expect(User.bash_admins).to eq([@bash_admin, @second_bash_admin])
  end

  it 'should properly add win to user' do
    @old_score = @user.score
    expect(@user.add_win.score).to eq(@old_score + 2)
  end

  it 'should properly add draw to user' do
    @old_score = @user.score
    expect(@user.add_draw.score).to eq(@old_score + 1)
  end
end
