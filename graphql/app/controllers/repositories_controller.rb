class RepositoriesController < ApplicationController
  
  IndexQuery = GitHub::Client.parse <<-'GRAPHQL'
    
    query {
      
      repositoryOwner(login: "google") {
        ...Views::Repositories::Index::Viewer
      }
    }
  GRAPHQL

  # GET /repositories
  def index
    
    data = query IndexQuery



    if params[:format] == 'csv'
      generate_csv_headers("negotiations-#{Time.now.strftime("%Y%m%d")}", params[:query]) 
    end
    render "repositories/index", locals: {
      viewer: data.repositoryOwner
    }
  end


  # Define query for "Show more repositories..." AJAX action.
  MoreQuery = GitHub::Client.parse <<-'GRAPHQL'
    
    query($after: String!) {
      repositoryOwner(login: "google") {
        repositories(first: 10, after: $after) {
          
          ...Views::Repositories::Repositories::RepositoryConnection
        }
      }
    }
  GRAPHQL

  # GET /repositories/more?after=CURSOR
  def more
    # Execute the MoreQuery passing along data from params to the query.
    data = query MoreQuery, after: params[:after]


    render partial: "repositories/repositories", locals: {
      repositories: data.repositoryOwner.repositories
    }
  end


  # Define query for repository show page.
  ShowQuery = GitHub::Client.parse <<-'GRAPHQL'
    # Query is parameterized by a $id variable.
    query($id: ID!) {
      # Use global id Node lookup
      node(id: $id) {
        # Include fragment for app/views/repositories/show.html.erb
        ...Views::Repositories::Show::Repository
      }
    }
  GRAPHQL

  # GET /repositories/ID
  def show
    
    data = query ShowQuery, id: params[:id]

    if repository = data.node
      render "repositories/show", locals: {
        repository: repository
      }
    else

      head :not_found
    end
  end

  StarMutation = GitHub::Client.parse <<-'GRAPHQL'
    mutation($id: ID!) {
      star(input: { starrableId: $id }) {
        starrable {
          ...Views::Repositories::Star::Repository
        }
      }
    }
  GRAPHQL


    def generate_csv_headers(filename, all_data)
      puts "werty"

    p @all_data = all_data
    
    puts "wdone"
    end

  def store
    puts "werty"
    puts params[:data]
    puts "wdone"
  end
end
