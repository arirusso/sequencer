module Sequencer 

  # Synchronize clocks
  class Sync

    # Class methods for managing sync objects
    class << self

      include Enumerable

      # Activate sync for the given master syncable
      # @param [Syncable] syncable The master to activate sync for
      # @param [Hash] options
      # @option options [Boolean] :immediate Whether to force sync immediately, or wait for the next cycle
      # @return [Array<Syncable>] Syncables for which sync was activated
      def activate_queued(syncable, options = {})
        Sync[syncable].activate_queued(options) unless Sync[syncable].nil?
      end

      # The collection of sync objects
      # @return [Array<Sync>]
      def sync
        @sync ||= {}
      end

      def each(&block)
        sync.values.each(&block)
      end

      # Get a single sync object based on the given master
      # @return [Sync]
      def [](master)
        sync[master]
      end

      # Add the given sync
      # @param [Sync]
      # @return [Sync]
      def <<(sync)
        self.sync[sync.master] = sync
      end
      
      # Set the sync object for the given master
      # @param [Syncable] master The master syncable of the sync
      # @param [Sync] sync
      # @return [Sync]
      def []=(master, sync)
        self.sync[master] = sync
      end

    end
    
    attr_reader :master, # the master syncable that controls the tempo
                :slave_queue, # a queue of syncables to begin sync for on the next cycle
                :slaves # syncables that are controlled by the master
    
    # @param [Syncable] master The master syncable for this sync
    # @param [Hash] options
    # @option options [Array<Syncable>, Syncable] :slave Slave syncable(s) to sync (also: :slaves)
    def initialize(master, options = {})
      @master = master
      @slave_queue = {}
      @slaves = options[:slaves] || [options[:slave]].flatten
    end
    
    # Sync the given syncable to self
    # pass :now => true to queue the sync to happen immediately
    # otherwise the sync will happen at the beginning of self's next sequence
    # @param [Syncable] syncable
    # @param [Hash] options
    # @option options [Boolean] :now Whether to sync now or wait for the next sync point
    # @return [Boolean]
    def add(syncable, options = {})
      @slave_queue[syncable] = !!options[:now]
      true               
    end
    
    # Is the given syncable a slave?
    # @param [Syncable] syncable
    # @return [Boolean]
    def slave?(syncable)
      @slaves.include?(syncable) || @slave_queue.include?(syncable)
    end

    # Is the given syncable master or slave?
    # @param [Syncable] syncable
    # @return [Boolean]
    def include?(syncable)
      slave?(syncable) || @master == syncable
    end
    
    # Stop sending sync to syncable
    # @param [Syncable] syncable
    # @return [Boolean]
    def remove(syncable)
      @slaves.delete(syncable)
      @slave_queue.delete(syncable)
      syncable.clock.unpause
      true
    end

    # All of the syncables, master and slaves
    # @return [Array<Syncable>]
    def syncables
      [@master] + @slaves
    end
    
    # Stop all of the syncables
    # @return [Boolean]
    def stop
      syncables.each(&:stop)
      true
    end
    
    # Start all of the syncables
    # @return [Boolean]
    def start
      syncables.each(&:start)
      true
    end
    
    # Sync is not in effect until slaves are moved from the queue to the slaves set by this method
    # @param [Hash] options
    # @option options [Boolean] :immediate Whether to sync immediately, or wait for the next cycle
    # @return [Array<Syncable>] The syncables who sync was activated for
    def activate_queued(options = {})
      to_sync = @slave_queue
      to_sync.select! { |syncable, sync_now| sync_now } unless !!options[:immediate]
      to_sync.map do |syncable, sync_now|
        @slaves << syncable
        syncable.start(:suppress_clock => true) unless syncable.running?
        syncable.clock.pause
        @slave_queue.delete(syncable)
        syncable
      end
    end
          
  end
  
end
