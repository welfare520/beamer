# encoding: UTF-8

require 'json'
require 'sinatra'
require "sinatra/namespace"
require 'yaml'
require 'virtus'
require 'fileutils'
require 'mongo'

ENV['RACK_ENV'] ||= 'development'

Dir.glob('./{config,lib,models,middleware,helpers,controllers}/*.rb').each { |file| require file }

BaseModel.setup_mongodb(Mongo::Client.new([ '127.0.0.1:12345' ], :database => 'beamer'))
 
use Login
use Authentication 
run ApplicationController
