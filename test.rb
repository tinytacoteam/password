require 'openssl'
require 'base64'
require 'json'
require 'date'
require 'securerandom'
require 'pry'

class Crypto
  attr_accessor :password, :iv
  ALG = 'AES-256-CBC'

  def initialize(password, iv)
    @password = password
    @iv = iv
  end

  def key
    Digest::SHA256.digest(password)
  end

  def iv
    Base64.decode64(@iv)
  end

  def self.generate_iv
    Base64.encode64(OpenSSL::Cipher::Cipher.new(ALG).random_iv).chomp
  end

  def cipher(type)
    aes = OpenSSL::Cipher::Cipher.new(ALG)
    aes.send(type)
    aes.key = key
    aes.iv = iv
    aes
  end

  def encrypt(text)
    aes = cipher(:encrypt)
    Base64.encode64(aes.update(text) + aes.final)
  end

  def decrypt(data)
    aes = cipher(:decrypt)
    aes.update(Base64.decode64(data)) + aes.final
  end

  def self.setup
    iv = 'zAppd54VeAra5GxF60UaIw=='
    Crypto.new('foobar', iv)
  end
end

binding.pry
