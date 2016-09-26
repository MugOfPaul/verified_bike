class VisitorsController < ApplicationController
  def letsencrypt
    render text: Rails.application.secrets.lets_encrypt
  end
end
