require 'rails_helper'

describe 'Task' do
  describe 'create task' do
    before do
      @task = FactoryBot.create(:task, title: 'タイトルA', text: '詳細A')
    end

    it 'create task date and time' do
      @tasks = Task.all.order(created_at: :desc)
    end
  end
end
