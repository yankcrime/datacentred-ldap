require 'rubygems' if RUBY_VERSION < '1.9.0' && Puppet.version < '3'
require 'net/ldap' if Puppet.features.net_ldap?

Puppet::Type.type(:ldap_entry).provide(:ldap) do
  confine :feature => :net_ldap

  public

  require 'set'

  def exists?
    disable_ssl_verify if (resource[:self_signed] == true)
    @ssl = true if (resource[:ssl] == true)
    status, results = ldap_search([resource[:host], resource[:port], resource[:username], resource[:password],
                   {:base => resource[:name], :attributes => attributes(resource[:attributes])}])
    if status == LDAP::NoSuchObject
      return false
    elsif status == LDAP::Success
      results.select{|r| r.dn == resource[:name]}.each do |entry|
        @entry = entry
        @mutable = [resource[:mutable]].flatten
        matching = resource[:attributes].all? do |k, _|
          return false unless entry.respond_to?(k)
          return true if @mutable.include? k
          entry.send(k).sort.join(",").force_encoding('UTF-8') == [resource[:attributes][k]].flatten.sort.join(",")
        end
        return matching
      end
      return nil if results.empty?
    else
      raise "LDAP Error #{status}: #{results}. Check server log for more info."
    end
  end

  def destroy
    status, message = ldap_remove([resource[:host], resource[:port], resource[:username], resource[:password],
          {:dn => resource[:name]}])
    raise "LDAP Error #{status}: #{message}. Check server log for more info." unless status == LDAP::Success
  end

  def create
    if @entry
      resource[:attributes].each do |k, v|
        if @entry.respond_to?(k)
          next if @mutable.include? k
          unless @entry.send(k).to_set == [v].flatten.to_set
            ldap_replace_attribute([resource[:host], resource[:port], resource[:username], resource[:password],
                        [resource[:name], k, v]])
          end
        else
          ldap_add_attribute([resource[:host], resource[:port], resource[:username], resource[:password],
                        [resource[:name], k, v]])
        end
      end
    else
      status, message = ldap_add([resource[:host], resource[:port], resource[:username], resource[:password],
                          {:dn => resource[:name], :attributes => resource[:attributes]}])
    end
    raise "LDAP Error #{status}: #{message}. Check server log for more info." unless status == LDAP::Success
  end

  private

  def attributes(attrs)
    return [] unless resource[:attributes]
    attrs.keys.map(&:to_s)
  end

  def ldap_search(args)
    ldap = ldap(args)
    Puppet.debug("LDAP Search: #{params(args).inspect}")
    args = params(args)
    result = ldap.search(args)
    code, message = return_code_and_message(ldap)

    if(code == LDAP::Success)
      [code, result]
    else
      [code, message]
    end
  end

  def ldap_add(args)
    ldap = ldap(args)
    Puppet.info("LDAP Add: #{params(args).inspect}")
    ldap.add(params(args))
    return_code_and_message(ldap)
  end

  def ldap_remove(args)
    ldap = ldap(args)
    Puppet.info("LDAP Remove: #{params(args).inspect}")
    ldap.delete(params(args))
    return_code_and_message(ldap)
  end

  def ldap_add_attribute(args)
    ldap = ldap(args)
    Puppet.info("LDAP Add Attribute: #{params(args).inspect}")
    ldap.add_attribute(*params(args))
    return_code_and_message(ldap)
  end

  def ldap_replace_attribute(args)
    ldap = ldap(args)
    Puppet.info("LDAP Replace Attribute: #{params(args).inspect}")
    ldap.replace_attribute(*params(args))
    return_code_and_message(ldap)
  end

  def ldap(args)
    host, port, admin_user, admin_password, _ = args
    ldap = Net::LDAP.new({:host => host, :port => port, :auth => {:method => :simple,
                          :username => admin_user, :password => admin_password}}.
                          merge(@ssl ? {:encryption => :simple_tls} : {}))
    Puppet.debug("Connecting to LDAP server ldaps://#{host}:#{port}")
    ldap.bind
    ldap
  end

  def params(args)
    args[4]
  end

  def return_code_and_message(ldap)
    result = ldap.get_operation_result
    return result.code, LDAP.lookup_error(result.code)
  end

  # For more, see http://www.zytrax.com/books/ldap/ch12/
  module LDAP
    Success                      = 0
    OperationsError              = 1
    ProtocolError                = 2
    TimeLimitExceeded            = 3
    SizeLimitExceeded            = 4
    CompareFalse                 = 5
    CompareTrue                  = 6
    StrongAuthNotSupported       = 7
    StrongAuthRequired           = 8
    OnlyPartialResultsReturned   = 9
    LdapReferral                 = 10
    AdminLimitExceeded           = 11
    UnavailableCriticalExtension = 12
    ConfidentialityRequired      = 13
    SaslBindInProgress           = 14
    NoSuchAttribute              = 16
    UndefinedAttributeType       = 17
    InappropriateMatching        = 18
    ConstraintViolation          = 19
    AttributeOrValueExists       = 20
    InvalidSyntax                = 21
    NoSuchObject                 = 32
    AliasProblem                 = 33
    InvalidDNSyntax              = 34
    ObjectIsLeaf                 = 35
    AliasDereferenceProblem      = 36
    InappropriateAuthentication  = 48
    InvalidCredentials           = 49
    InsufficientAccessRights     = 50
    Busy                         = 51
    Unavailable                  = 52
    UnwillingToPerform           = 53
    LoopDetected                 = 54
    NamingViolation              = 64
    ObjectClassViolation         = 65
    NotAllowedOnNonLeaf          = 66
    NotAllowedOnRDN              = 67
    EntryAlreadyExists           = 68
    NoObjectClassModifications   = 69
    ResultsTooLarge              = 70
    AffectsMultipleDSAs          = 71
    UnknownError                 = 80

    def self.lookup_error(code)
      Hash[constants.collect{|c| [
        LDAP.const_get(c), c.to_s.gsub(/([A-Z])/, ' \1').strip
      ]}][code]
    end
  end

  # Re-open the SSL context class and disable SSL verification
  # Needed for self-signed certs
  require 'openssl'
  def disable_ssl_verify
    if OpenSSL::SSL::SSLContext.new.verify_mode != OpenSSL::SSL::VERIFY_NONE
      OpenSSL::SSL::SSLContext.class_eval do
        alias_method :original, :initialize
        def initialize
          original
          @verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
      end
    end
  end
end
