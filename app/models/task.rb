class Task
	include ActiveModel::Model

    def self.get_running_backup
        if $redis.get("running-backup").nil?
            return []
        end
        return eval $redis.get("running-backup")
    end

    def self.get_running_restore
        if $redis.get("running-restore").nil?
            return []
        end
        return eval $redis.get("running-restore")
    end

    def self.add_backup id
        running_backup = []
        unless $redis.get("running-backup").nil?
            running_backup = eval $redis.get("running-backup")
        end
        running_backup.append(id)
        $redis.set("running-backup", running_backup.to_s)
    end

    def self.add_restore id
        running_restore = []
        unless $redis.get("running-restore").nil?
            running_restore = eval $redis.get("running-restore")
        end
        running_restore.append(id)
        $redis.set("running-restore", running_restore.to_s)
    end

    def self.remove_backup id
        running_backup = eval $redis.get("running-backup")
        running_backup = running_backup - [id]
        $redis.set("running-backup", running_backup.to_s)
    end

    def self.remove_restore id
        running_restore = eval $redis.get("running-restore")
        running_restore = running_restore - [id]
        $redis.set("running-restore", running_restore.to_s)
    end

end