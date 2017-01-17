# provide a scrivito user based on the 'solidus_auth_devise' gem
module SpreeScrivitoUser
  def self.to_scrivito_user(spree_user)
    # return nil, when no user is given
    return if spree_user.blank?

    # return nil, when _not_ admin
    return unless spree_user.admin?

    # return new Scrivito::User
    Scrivito::User.define(spree_user.id.to_s) do |user|
      user.description {
        spree_user.login
      }
      user.suggest_users do |input|
        Spree::User.search(login: input).result.map do |found_user|
          to_scrivito_user(found_user)
        end
      end

      # allow everything
      Scrivito::User::VERBS.each { |can_have| user.can_always(can_have, :workspace) }
    end
  end
end
