module LDAPHelper

  def ldap(args)
    host, port, admin_user, admin_password, _ = args
    ldap = Net::LDAP.new(:host => host, :port => port, :method => :simple,
                          :username => admin_user, :password => admin_password)
    ldap.bind
    ldap
  end

  def params(args)
    args[4]
  end

  def return_code_and_message(ldap)
    result = ldap.get_operation_result
    return result.code, result.message
  end
  
end