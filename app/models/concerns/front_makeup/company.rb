class FrontMakeup::Company
  class Scope < CompanyPolicy::Scope
    def resolve(req)
      case req["relationship_to_company"]
      when "owned"
        scope.where(id: user.owned_companies)
      when "admin"
        owned_ids = user.owned_companies.pluck(:id)
        admin_ids = user.admin_of_companies.pluck(:id)
        merged = (owned_ids + admin_ids).uniq
        scope.where(id: merged)
      when "member"
        scope.where(id: user.connected_to_companies)
      else
        scope.where(id: user.connected_to_companies)
      end
    end

    def serve_request(req)
      #byebug
      Jbuilder.new do |jb|
        jb.array! resolve(req).to_a do |c|
          if c.user_is_admin?(user)
            FrontMakeup::Company.serve_traits(c, req, jb)
            jb.admin true
            jb.owner c.user == user
            jb.set! :departments do
              jb.array! c.departments do |d|
                jb.id d.id
                jb.name d.name
                jb.admin true
                jb.n_members d.members.size
              end
            end
          end
          FrontMakeup::Company.serve_regular(c,jb)
        end
      end
    end
  end

  attr_reader :company, :user
  def initialize(company, user)
    @company = company
    @user = user
  end

  def self.serve_traits(elem, req, jb)
    if req && req.keys.include?("number_of_departments")
      jb.number_of_departments elem.departments.size
    end

    if req && req.keys.include?("number_of_employees")
      jb.number_of_employees elem.employees.size
    end
  end

  def self.serve_regular(elem, jb)
    jb.id elem.id
    jb.name elem.name
  end

  def to_build_for(req = {})
    Jbuilder.new do |jb|
      if company.user_is_admin?(user)
        self.class.serve_traits(company, req["traits"], jb)
        jb.admin true
        jb.set! :departments do
          jb.array! company.departments, :name
        end
      end
      self.class.serve_regular(company,jb)
    end
  end
end
