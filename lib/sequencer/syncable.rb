module Sequencer 

  # Included by Clock to add syncing capability
  module Syncable

    # Is this clock master of the given syncable?
    # @param [Syncable] slave
    # @return [Boolean]
    def has_sync_slave?(slave)
      !Sequencer::Sync[self].nil? && Sequencer::Sync[self].slave?(slave)
    end

    # Is this clock slave to the given syncable?
    # @param [Syncable] master
    # @return [Boolean]
    def has_sync_master?(master)
      !Sequencer::Sync[master].nil? && Sequencer::Sync[master].slave?(self)
    end

    # Is this syncable sync'd to the given syncable either as master or slave?
    # @param [Syncable] syncable
    # @return [Boolean]
    def synced_to?(syncable)
      has_sync_slave?(syncable) || has_sync_master?(syncable)
    end
    alias_method :synced?, :synced_to?
    alias_method :sync?, :synced_to?

    # Add the given syncable as a slave
    # @param [Syncable] slave
    # @return [Sync] The sync object to which syncable was added as a slave
    def sync(slave)
      Sequencer::Sync[self] ||= Sequencer::Sync.new(self, :slave => slave)
    end

    # Stop sending sync to/from the given syncable
    # @param [Syncable] syncable
    # @return [Boolean]
    def unsync(syncable)
      !Sync[self].nil? && Sync[self].destroy | unsync_from(syncable) 
    end

    # Add this syncable as a slave to the given syncable
    # @param [Syncable] master
    # @return [Sync] The sync object to which this syncable was added as a slave
    def sync_to(master)
      Sequencer::Sync[master] ||= Sequencer::Sync.new(master, :slave => self)
    end

    # Stop receiving sync from syncable
    # @param [Syncable] master
    # @return [Boolean]
    def unsync_from(master)
      !Sequencer::Sync[syncable].nil? && Sequencer::Sync[syncable].remove(self)
    end

    private

    # Activate sync on this syncable's slaves
    # The passed in callback is yielded to during the process
    def activate_sync(&block)
      sync_immediate if sync_immediate?
      yield if block_given?
      sync_enqueued
    end

    def sync_immediate?
      respond_to?(:activate_sync?) && send(:activate_sync?)
    end

    # Start sync for any enqueued slaves that were specified to start given the current state
    def sync_enqueued
      Sync.activate_queued(self) 
    end

    # Start sync immediately for any enqueued slaves without condition
    def sync_immediate
      Sync.activate_queued(self, :immediate => true) 
    end

  end
end
