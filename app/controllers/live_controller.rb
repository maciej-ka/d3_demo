class LiveController < WebsocketRails::BaseController
  # todo way to broadcast from regular controller
  # def create
  #   user = User.find(message["id"])
  #   broadcast_message :create_success, user, namespace: :users
  # end
  #
  # def update
  #   user = User.find(message["id"])
  #   broadcast_message :update_success, user, namespace: :users
  # end
  #
  # def delete
  #   user = User.find(message["id"])
  #   broadcast_message :delete_success, user, namespace: :users
  # end
end
