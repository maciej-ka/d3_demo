class LiveController < WebsocketRails::BaseController
  # todo: find a way to broadcast from regular controller, and bring this back!
  # def create
  #   user = User.create! message
  #   broadcast_message :create_success, user, namespace: :users
  # end
  #
  # def update
  #   user = User.find(message["id"])
  #   user.update! message
  #   broadcast_message :update_success, user, namespace: :users
  # end
  #
  # def delete
  #   user = User.find(message["id"])
  #   user.destroy!
  #   broadcast_message :delete_success, user, namespace: :users
  # end
end
