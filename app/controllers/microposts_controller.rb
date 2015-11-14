class MicropostsController < ApplicationController
      before_action :logged_in_user, only: [:create, :destroy]
      before_action :correct_user,   only: :destroy  # NEW LINE
      
      def create
      	secure_post = params.require(:micropost).permit(:content)
        @micropost = current_user.microposts.build(secure_post) 
        if @micropost.save
          flash[:success] = "Micropost created!"
          redirect_to root_url
        else
           @feed_items = []
          render 'static_pages/home'
        end
      end
      # UPDATED IMPLEMENTATION
      def destroy
            @micropost.destroy
            redirect_to root_url
      end

           # NEW PRIVATE METHOD
      private
         def correct_user
              @micropost = current_user.microposts.find_by(id: params[:id])
              redirect_to root_url if @micropost.nil?
         end
    end