#
# Cookbook Name:: spree
# Recipe:: default
#
# Devloft Solutions, Inc.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

apt_update 'update apt cache' do
  action :update
end

execute 'gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3'

include_recipe 'spree::app'
include_recipe 'spree::unicorn'
include_recipe 'spree::database'
include_recipe 'spree::bundle'
include_recipe 'spree::web_proxy'
