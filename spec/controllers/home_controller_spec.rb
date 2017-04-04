require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #submit" do
    it "uploads and parses input file successfully" do
      filename = Rails.root.join('spec/fixtures/samples', "battleship_data.txt")
      @file = fixture_file_upload(filename, 'text/plain')
      post :submit, params: { battleship_data: @file }
      expect(response).to have_http_status(:success)
      expect(assigns(:res)).not_to be_nil
      expect(assigns(:err_message)).to be_nil
    end

    it "returns error when calling method without a file" do
      post :submit
      expect(response).to have_http_status(:success)
      expect(assigns(:res)).to be_nil
      expect(assigns(:err_message)).to eq("File must be a .txt file")
    end

    it "returns error when uploaded file is not a txt file" do
      filename = Rails.root.join('spec/fixtures/samples', "invalid_file.xlsx")
      @file = fixture_file_upload(filename, 'text/plain')
      post :submit, params: { battleship_data: @file }
      expect(response).to have_http_status(:success)
      expect(assigns(:res)).to be_nil
      expect(assigns(:err_message)).to eq("File must be a .txt file")
    end

    it "returns error when data is not proper [1]" do
      filename = Rails.root.join('spec/fixtures/samples', "location_does_not_exist.txt")
      @file = fixture_file_upload(filename, 'text/plain')
      post :submit, params: { battleship_data: @file }
      expect(response).to have_http_status(:success)
      expect(assigns(:res)).to be_nil
      expect(assigns(:err_message)).to eq("B6 does not exist in battle ground")
    end

    it "returns error when data is not proper [2]" do
      filename = Rails.root.join('spec/fixtures/samples', "conflict_position.txt")
      @file = fixture_file_upload(filename, 'text/plain')
      post :submit, params: { battleship_data: @file }
      expect(response).to have_http_status(:success)
      expect(assigns(:res)).to be_nil
      expect(assigns(:err_message)).to eq("F3 is acquired by more than one player")
    end
  end

end
