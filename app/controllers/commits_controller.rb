class CommitsController < ApplicationController
  include Concerns::Resource

  before_action :find_resources, only: %w(index)
  before_action :new_resource, only: %w(create new)
  before_action :find_resource, only: %w(show update destroy edit)
  before_action :set_user, only: %(update_author)

  def parse
    logger.info "Parse params #{parse_params}"

    User.destroy_all

    if find_repo
      commits.each do |commit|
        user = find_user(commit)
        if user
          user.commits.create(sha: commit.sha,
              message: commit.commit.message,
              user: user,
              date: commit.commit.author.date)
        end

      end

      @response[:messages] << "#{commits.length} commits loaded"
      @response[:success] = true
    else
      @response[:errors] << 'Repo not found'
    end


    send_response @response
  end

  def update_author
    logger.info "Update author params #{commit_author_params}"
    if @user and @user.update_attributes(name: commit_author_params[:name])
      @response[:success] = true
      @response[:messages] << 'Name saved'
    end
    send_response @response
  end

  def find_user_repos
    begin
      @response[:repos] = $github.repos.list(user: parse_params[:user]).map(&:name)
      @response[:success] = true
    rescue Github::Error::NotFound => e
      @response[:repos] = []
    end

    send_response @response
  end

  def find_user(commit)
    User.find_or_create_by(name: commit.commit.author.name, email: commit.commit.author.email)
  end

  def find_repo
    $github.repos.list(user: parse_params[:user]) do |repo|
      logger.info "Repo #{repo.name}"
      return true if repo.name.eql? parse_params[:repo]
    end
    false
  end

  def commits
    commits = []
    begin
      commits = $github.repos.commits.all(parse_params[:user],parse_params[:repo])
    rescue Github::Error::NotFound => e
      logger.info e
      #
    end
    commits
  end

  def resource_scope
    Commit
  end

  def resource_serializer
    CommitSerializer
  end

  def resource_symbol
    :commit
  end

  def search_by
    [:commit]
  end

  def permitted_params
    [ :id ]
  end

  private

  def set_user
    @user = User.find(commit_author_params[:id])
  end

  def commit_author_params
    params.require(:commit).permit(:name, :id)
  end

  def parse_params
    params.permit(:user, :repo)
  end
end
