module SessionsHelper
# Remembers a user in a persistent session.
    def logged_in_user
        unless logged_in?        #must be called before executing the micropost controller's create or destroy actions. 
          flash[:notice] = "Please log in"
          redirect_to login_url
        end
    end 



      def remember(user)
        user.remember
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
      end



      def create
        user = User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
          remember user       # NEW LINE
          redirect_to user
        else
          flash.now[:danger] = 'Invalid email/password combination'
          render 'new'
        end
      end



      # Returns the user corresponding to the remember token cookie.
      def current_user
        if (user_id = cookies.signed[:user_id])
           user = User.find_by(id: user_id)
           if user 
              @current_user = user
           end
        end
      end



      def current_user
        if (user_id = cookies.signed[:user_id])
           user = User.find_by(id: user_id)
           if user && 
                user.authenticated?(cookies[:remember_token])
            @current_user = user
          end
        end
      end

      
      # Returns true if a user is logged in, false otherwise.
      def logged_in?
        !current_user.nil?
      end
      # Returns true if the given user is the current user.
      def current_user?(user)
        user == current_user
      end
      # Forgets a persistent session.
      def forget(user)
          user.forget
          cookies.delete(:user_id)
          cookies.delete(:remember_token)
      end

      # Logs out the current user.
      def log_out
          forget(current_user)
          @current_user = nil
      end
end
