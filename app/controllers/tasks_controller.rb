class TasksController < ApplicationController
  # タスクの検索結果の一覧を取得
  # @return [Array<Task>] タスクの検索結果
  def index
    search_title
    search_status
    search_label
    sort_tasks
  end

  # タスクの詳細画面を取得
  # @return [Task]
  def show
    @task = Task.find(params[:id])
  end

  # タスクの新規作成画面を取得
  # @return [Task]
  def new
    @task = Task.new
  end

  # タスクの編集画面を取得
  # @return [Task]
  def edit
    @task = Task.find(params[:id])
  end

  # 自身のuser.idと紐づくタスクを作成
  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      flash[:success] = 'タスクを登録しました。'
      redirect_to tasks_path
    else
      flash.now[:danger] = 'タスクの登録が失敗しました。'
      render 'new'
    end
  end

  # タスクの更新
  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path
      flash[:success] = 'タスクを変更しました。'
    else
      flash.now[:danger] = 'タスクの変更に失敗しました。'
      render 'edit'
    end
  end

  # タスクの削除
  def destroy
    @task = Task.find(params[:id])
    if @task.destroy
      redirect_to tasks_path
      flash[:success] = 'タスクを削除しました。'
    else
      flash[:danger] = 'タスクの削除に失敗しました。'
      redirect_to tasks_path
    end
  end

  private

  # パラメータの許可
  # @return [ActionController::Parameters] 許可されたパラメータ
  def task_params
    params.require(:task).permit(:title, :text, :deadline, :status, :priority, label_ids: [])
  end

  # タスクをタイトルで検索
  # @return [Array<Task>] タイトル検索の結果
  def search_title
    @tasks = params[:title].present? ? current_user.tasks.preload(:labels).where('title LIKE ?', "%#{params[:title]}%") : current_user.tasks.preload(:labels)
    @tasks = @tasks.page(params[:page]).per(5)
  end

  # タスクをステータスで検索
  # @return [Array<Task>] ステータス検索の結果
  def search_status
    @tasks = @tasks.where('status = ?', params[:status]) if params[:status].present?
  end

  # タスクをラベルで検索
  # @return [Array<Task>] ラベル検索の結果
  def search_label
    @tasks = @tasks.joins(:labels).where(labels: { id: params[:label_id] }) if params[:label_id].present?
  end

  # タスクをソート
  # 優先度が未選択なら、作成日時で降順
  # @return [Array<Task>] タスクのソート結果
  def sort_tasks
    @tasks = case params[:keyword]
             when 'high'
               @tasks.order('priority')
             when 'low'
               @tasks.order('priority DESC')
             else
               @tasks.order('created_at DESC')
             end
  end
end
