module Tasks
  class Updater
    include Interactor::Organizer

    organize Tasks::Create::PrepareParams,
             Tasks::Update
  end
end
