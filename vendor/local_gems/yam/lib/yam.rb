# Copyright (c) Microsoft Corporation
# All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# THIS CODE IS PROVIDED *AS IS* BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY
# IMPLIED WARRANTIES OR CONDITIONS OF TITLE, FITNESS FOR A PARTICULAR
# PURPOSE, MERCHANTABLITY OR NON-INFRINGEMENT.
#
# See the Apache Version 2.0 License for specific language governing
# permissions and limitations under the License.
#
require "yam/version"
require "yam/configuration"
require "yam/client"

module Yam
  extend Configuration

  class << self

    # Handle for the client instance
    attr_accessor :api_client

    # Alias for Yam::Client.new
    #
    # @return [Yam::Client]
    def new(oauth_token, endpoint)
      # @oauth_token = oauth_token
      # @endpoint = endpoint
      @api_client = Yam::Client.new(oauth_token, endpoint)
    end

    # Delegate to Yam::Client
    #
    # def method_missing(method, *args, &block)
    #   return super unless new(@oauth_token, @endpoint).respond_to?(method)
    #   new(@oauth_token, @endpoint).send(method, *args, &block)
    # end

    # def respond_to?(method, include_private = false)
    #   new(@oauth_token, @endpoint).respond_to?(method, include_private) || super(method, include_private)
    # end
  end
end
