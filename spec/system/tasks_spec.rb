require 'rails_helper'

describe 'Task' do
  describe 'create task' do
    before do
      FactoryBot.create(:task, title: 'タイトルA', text: '詳細A')
    end

    it 'returns tasks sorted in descending order of creation date' do
      visit tasks_path
      @tasks = Task.all.order(created_at: :desc)
    end
  end
end
