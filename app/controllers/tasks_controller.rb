class TasksController < ApplicationController
  # タスクの検索結果の一覧を取得
  # @return [Array<Task>] タスクの検索結果
  def index
    title_search
    status_search
    tasks_sort
  end

  # idに対応したタスクを取得
  # @return [Task] idに対応したタスク
  def show
    @task = Task.find(params[:id])
  end

  # タスクのインスタンスを取得
  # @return [Task]
  def new
    @task = Task.new
  end

  # idに対応したタスクを取得
  # @return [Task] idに対応したタスク
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

  # idに対応したタスクを取得
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

  # idに対応したタスクを取得
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
    params.require(:task).permit(:title, :text, :deadline, :status, :priority)
  end

  # タスクをタイトルで検索
  # @return [Array<Task>] タイトル検索の結果
  def title_search
    @tasks = params[:title].present? ? Task.where('title LIKE ?', "%#{params[:title]}%") : current_user.tasks
    @tasks = @tasks.page(params[:page]).per(5)
  end

  # タスクをステータスで検索
  # @return [Array<Task>] ステータス検索の結果
  def status_search
    @tasks = @tasks.where('status = ?', params[:status]) if params[:status].present?
  end

  # タスクをソート
  # 優先度が未選択なら、作成日時で降順
  # @return [Array<Task>] タスクのソート結果
  def tasks_sort
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
