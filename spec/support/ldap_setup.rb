module LDAPSetup
  def ldap_setup
    @server_details = ['127.0.0.1', 8389, 'admin', 'Qqb8QC_wBeK!gch']
    host, port, username, password = @server_details
    ldap_params = {:host => host, :username => username, :password => password, :port => port, :method => :simple}
    @mock_ldap = mock(:bind => true)
    @mock_ldap.expects(:get_operation_result).returns(mock(:code => 0, :message => 'success'))
    Net::LDAP.expects(:new).with(ldap_params).returns(@mock_ldap)
  end
end