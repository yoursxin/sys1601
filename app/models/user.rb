class User < ActiveRecord::Base  

  before_save { self.email = email.downcase }
  before_create :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }  
  validates :email, presence: true,            
            uniqueness: { case_sensitive: false }
  has_secure_password
  #validates :password, length: { minimum: 6 }
  
  scope :with_role, -> role { where("roles_mask & #{2**ROLES.index(role.to_s)} > 0 ") }
  
  ROLES = %w[票据录入岗  票据审核岗 资金录入岗 资金审核岗 ADMIN] 

  def roles=(roles)    
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum    
  end
  
  def roles  
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end
  
  def role_symbols
    roles.map(&:to_sym)
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end 

  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end 
