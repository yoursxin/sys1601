class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user
    can :index, Pjmr
    can :index, Zjtz
    can [:show, :new, :edit, :update], User
    
    if user.role? :ADMIN
        can [:index, :create, :adminEdit, :adminUpdate, :destroy], User       
    end
    
    if user.role? :票据录入岗
        can [:lrIndex, :import, :rksq, :rkIndex, :cksq, :ckpledit, :ckplsq], Pjmr       
    end

    if  user.role? :票据审核岗
        can [:rkdshIndex, :rksh, :ckdshIndex, :cksh], Pjmr      
    end

    if  user.role? :资金录入岗
        can [:lrIndex, :rjsq, :rjIndex, :cjsq, :cjpledit, :new, :create], Zjtz       
    end

    if  user.role? :资金审核岗
        can [:rjdshIndex, :rjsh, :cjdshIndex, :cjsh], Zjtz        
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
