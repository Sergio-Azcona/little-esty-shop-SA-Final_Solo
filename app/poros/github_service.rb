require 'httparty'
require './config/application'

class GitHubService
  def repo_information
    get_url('https://api.github.com/repos/eport01/little-esty-shop')
  end

  def pr_information 
    get_url('https://api.github.com/repos/eport01/little-esty-shop/pulls?state=closed')
  end

  def commits_information
    get_url("https://api.github.com/repos/eport01/little-esty-shop/commits?per_page=100")
  end

  def get_url(url)
    response = HTTParty.get(url, headers: { 'Authorization' => "Bearer #{ENV['GITHUB_API_KEY']}" })
    parsed = JSON.parse(response.body, symbolize_names: true)
  end
end

# views>layout>footer code
# <h3>Github Info</h3>
#       repo name: <%= @repo = RepoSearch.new.create_repo.name %>

#       <h4>Commits by User:</h4>
#         <% commit_info.each do |user, commit_num| %>
#           <p><%= "#{user} - #{commit_num}" %></p>
#         <% end %>

#       <h4>Pull Requests by User:</h4>
#         <% pr_info.each do |user, pr_num| %>
#           <p><%= "#{user} - #{pr_num}" %></p>
#         <% end %>