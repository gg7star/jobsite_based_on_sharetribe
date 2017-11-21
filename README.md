# Sharetribe

## Tech Stack

- Ruby 2.3  
- Ruby on Rails 4.2  
- MySQL  5.7
- React + jQuery
- Node.js 6.9 (for compiling JavaScript assets)
- "what you see is what you get" Editor [Mercury](http://jejacks0n.github.io/mercury/)  
- Deploy: Custom Script (not using Mina or Cap3)  
- Server: Heroku
- Image hosting: Amazon S3  
- Background job: `[delayed_job](https://github.com/collectiveidea/delayed_job)`
- Gem: 
    -  [devise](https://github.com/plataformatec/devise) | Authentication
    -  [omniauth-facebook](https://github.com/mkdynamic/omniauth-facebook) | Third party login: Facebook
    -  [haml](https://github.com/haml/haml) and ERB | HTML teamplating
    -  [mysql2](https://github.com/brianmario/mysql2) | MySQL library for Ruby
    -  [paperclip](https://github.com/thoughtbot/paperclip) | Image upload management
    -  [passenger](https://github.com/phusion/passenger) | Web application server
    -  [react_on_rails](https://github.com/shakacode/react_on_rails) | Integration of React + Webpack + Rails
    -  factory_girl, capybara, rspec-rails, cucumber-rails, selenium-webdriver | Testing

## Development 

* Create new branch off ```master``` prefixed with ```feature/``` or ```update/``` or ```bugfix/``` as appropriate. Example: ```feature/responsive-toolbar```
* Implement necessary changes
* Push branch to bitbucket and open a Pull Request against ```master```
* Assign ```PureGold``` as a reviewer
* Once the Pull Request has been approved, merge the branch and deploy
* Verify the changes on the Server after the change has been deployed

