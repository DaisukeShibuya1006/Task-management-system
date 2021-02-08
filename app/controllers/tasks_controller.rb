class TasksController < ApplicationController
  # タイトル検索
  # ステータス検索
  # タスクのソート
  # @return[Task]
  def index
    title_search
    status_search
    tasks_sort
  end

  # idに対応するタスクを取得
  # @return[Task] idに対応するタスク
  def show
    @task = Task.find(params[:id])
  end

  # タスクのインスタンスを生成
  # @return[Task] タスクのインスタンス
  def new
    @task = Task.new
  end

  # idに対応するタスクを取得
  # @return[Task] idに対応するタスク
  def edit
    @task = Task.find(params[:id])
  end

  # カレントユーザがタスクを作成
  # @return[Task] カレントユーザの作成したタスク
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

  # idに対応するタスクを取得
  # @return[Task] 更新したタスク
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

  # idに対応するタスクを取得
  # @return[Task] 削除したタスク
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

  # 許可されたカラムのみ通過
  # titleが入力されているか確認
  # titleが未入力の場合は作成失敗
  # @param title[String] 許可されたtitle
  # @param text[String] 許可されたtext
  # @param deadline[DateTime] 許可されたdeadline
  # @param status[Integer] 許可されたstatus
  # @param priority[Integer] 許可されたpriorty
  def task_params
    params.require(:task).permit(:title, :text, :deadline, :status, :priority)
  end

  # タスクをタイトルで検索
  # @return[Task] タイトル検索の結果
  def title_search
    @tasks = params[:title].present? ? Task.where('title LIKE ?', "%#{params[:title]}%") : current_user.tasks
    @tasks = @tasks.page(params[:page]).per(5)
  end

  # タスクをステータスで検索
  # @return[Task] ステータス検索の結果
  def status_search
    @tasks = @tasks.where('status = ?', params[:status]) if params[:status].present?
  end

  # タスクを優先度でソート
  # 優先度が未選択なら、作成日時で降順
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
