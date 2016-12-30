Rails.application.routes.draw do
  root "weather#index"
  get '*path' => redirect('/')
end
