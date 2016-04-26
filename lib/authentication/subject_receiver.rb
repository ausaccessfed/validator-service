# frozen_string_literal: true
module Authentication
  class SubjectReceiver
    include ShibRack::DefaultReceiver
    include ShibRack::AttributeMapping

    map_single_value shared_token:           'HTTP_AUEDUPERSONSHAREDTOKEN',
                     targeted_id:            'HTTP_TARGETED_ID',
                     principal_name:         'HTTP_PRINCIPALNAME',
                     # name:                   'HTTP_DISPLAYNAME',
                     display_name:           'HTTP_DISPLAYNAME',
                     cn:                     'HTTP_CN',
                     mail:                   'HTTP_MAIL',
                     o:                      'HTTP_O',
                     home_organization:      'HTTP_HOMEORGANIZATION',
                     home_organization_type: 'HTTP_HOMEORGANIZATIONTYPE'

    map_multi_value  affiliation:            'HTTP_EDUPERSONAFFILIATION',
                     scoped_affiliation:     'HTTP_EDUPERSONSCOPEDAFFILIATION'

    def subject(_env, attrs)
      puts "============"
      puts attrs
      puts "============"
      Subject.transaction do
        identifier = attrs.slice(:targeted_id)
        subject = Subject.find_or_initialize_by(identifier)

        # This is a temporary hack
        subject.enabled = true
        subject.complete = true
        subject.name = 'Some Bozo'
        subject.mail = attrs[:mail]
        subject.shared_token = attrs[:shared_token]
        subject.principal_name = attrs[:principal_name]
        subject.display_name = attrs[:display_name]
        subject.cn = attrs[:cn]
        subject.o = attrs[:o]
        subject.home_organization = attrs[:home_organization]
        subject.home_organization_type = attrs[:home_organization_type]

        ensure_subject_match(subject, attrs)
        subject.save(validate: false)
        update_affiliations(subject, attrs)
        update_scoped_affiliations(subject, attrs)
        subject.update!(attrs.except(:affiliation, :scoped_affiliation))

        subject
      end
    end

    def finish(_env)
      redirect_to('/dashboard')
    end

    def ensure_subject_match(subject, attrs)
      return unless subject.persisted?
      raise('Subject mismatch') if subject.shared_token != attrs[:shared_token]
    end

    def update_affiliations(subject, attrs)
      touched = []

      attrs[:affiliation].each do |value|
        touched << subject.affiliations.find_or_create_by!(value: value)
      end

      subject.affiliations.where.not(id: touched.map(&:id)).destroy_all
    end

    def update_scoped_affiliations(subject, attrs)
      touched = []

      attrs[:scoped_affiliation].each do |full_value|
        value, scope = full_value.split('@')
        touched << subject.scoped_affiliations
                   .find_or_create_by!(value: value, scope: scope)
      end

      subject.scoped_affiliations.where.not(id: touched.map(&:id)).destroy_all
    end
  end
end
