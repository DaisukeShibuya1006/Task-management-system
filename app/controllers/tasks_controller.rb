class TasksController < ApplicationController
  # title_search, status_search, tasks_sortメソッドを呼び出す
  def index
    title_search
    status_search
    tasks_sort
  end

  # idに対応するタスクを取得する
  # @return[Task] idに対応するタスクを取得
  def show
    @task = Task.find(params[:id])
  end

  # タスクのインスタンスを生成する
  # @return[Task] タスクのインスタンスを生成
  def new
    @task = Task.new
  end

  # idに対応するタスクを取得する
  # @return[Task] idに対応するタスクを取得
  def edit
    @task = Task.find(params[:id])
  end

  # ログイン中のユーザがタスクを保存する
  # @return[Task] ログイン中のユーザがタスクを保存
  def create
    @task = current_user.tasks.new(task_params)
    if @task.save
      flash[:success] = 'タスクを登録しました。'
      redirect_to tasks_path
    else
      flash.now[:danger] = 'タスクの登録が失敗しました。'
      render 'new'
      pp @task
    end
  end

  # idに対応するタスクを取得する
  # @return[Task] タスクの更新
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

  # idに対応するタスクを取得する
  # @return[Task] タスクの削除
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

  # 許可されたパラメータのみ通過させる
  # @param[ActionController::Parameters] 許可されたパラメータのみ通過
  def task_params
    params.require(:task).permit(:title, :text, :deadline, :status, :priority)
  end

  # タスクをタイトルで検索する
  # @return[Task] タイトル検索の結果
  def title_search
    @tasks = params[:title].present? ? Task.where('title LIKE ?', "%#{params[:title]}%") : current_user.tasks
    @tasks = @tasks.page(params[:page]).per(5)
  end

  # タスクをステータスで検索する
  # @return[Task] ステータス検索の結果
  def status_search
    @tasks = @tasks.where('status = ?', params[:status]) if params[:status].present?
  end

  # タスクを優先度でソートする
  # 優先度が未選択なら、作成日時で降順させる
  # @return[Task] 優先順位のソート結果
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
