class CommitSerializer < ActiveModel::Serializer
  attributes :id, :date, :user_id, :sha, :message, :email, :name

  def name
    object.try(:user).name
  end

  def email
    object.try(:user).email
  end
end