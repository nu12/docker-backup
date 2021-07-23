class Task
	include ActiveModel::Model

    # Dinamically create class methods 
    ["backup", "restore"].each do | method |
        define_singleton_method ("get_running_#{method}") { Task.get_running method }
        define_singleton_method ("add_#{method}") { | id | Task.add method, id }
        define_singleton_method ("remove_#{method}") { | id | Task.remove method, id }
    end

    private

    def self.get_running key
        if $redis.get(key).nil?
            return []
        end
        return eval $redis.get(key)
    end

    def self.add key, id
        running = []
        unless $redis.get(key).nil?
            running = eval $redis.get(key)
        end
        running.append(id)
        $redis.set(key, running.to_s)
    end

    def self.remove key, id
        running = eval $redis.get(key)
        running = running - [id]
        $redis.set(key, running.to_s)
    end
end