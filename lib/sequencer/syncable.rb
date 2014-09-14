module Sequencer 

  # Included by Clock to add syncing capability
  module Syncable

    # Callbacks that, when evaluated true, will trigger sync actions
    module EventTrigger

      # Set the sync trigger callback. When this syncable is in the slave queue and this callback 
      # evaluates true, sync will become active
      # @param [Proc] block
      # @return [Proc]
      def sync(&block)
        @sync = block
      end

      # Whether sync should become active for this slave
      # @return [Boolean]
      def sync?
        !@sync.nil? && @sync.call
      end

    end

    # Is this clock master of the given syncable?
    # @param [Syncable] slave
    # @return [Boolean]
    def has_sync_slave?(slave)
      !Sequencer::Sync[self].nil? && Sequencer::Sync[self].slave?(slave)
    end
    alias_method :syncs?, :has_sync_slave?

    # Is this clock slave to the given syncable?
    # @param [Syncable] master
    # @return [Boolean]
    def has_sync_master?(master)
      !Sequencer::Sync[master].nil? && Sequencer::Sync[master].slave?(self)
    end
    alias_method :synced_to?, :has_sync_master?

    # Is this syncable sync'd to the given syncable either as master or slave?
    # @param [Syncable] syncable
    # @return [Boolean]
    def sync?(syncable)
      has_sync_slave?(syncable) || has_sync_master?(syncable)
    end

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
      sync_immediate if @trigger.sync?
      yield
      sync_enqueued
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
