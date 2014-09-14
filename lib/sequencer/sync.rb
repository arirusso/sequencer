module Sequencer 

  # Synchronize clocks
  class Sync

    class << self

      include Enumerable

      def activate_queued(syncable, options = {})
        !Sync[syncable].nil? && Sync[syncable].activate_queued(options)
      end

      def sync
        @sync ||= {}
      end

      def each(&block)
        sync.values.each(&block)
      end

      def [](master)
        sync[master]
      end
      
      def []=(master, sync)
        self.sync[master] = sync
      end

    end
    
    attr_reader :master, # the master sequencer that controls the tempo
                :slave_queue, # a queue of sequencers to begin sync for on the next beat
                :slaves # sequencers that are controlled by the master
    
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
    def activate_queued(options = {})
      updated = []
      to_sync = @slave_queue
      to_sync.select! { |syncable, sync_now| sync_now } unless !!options[:immediate]
      to_sync.each do |syncable, sync_now|
        @slaves << syncable
        syncable.start(:suppress_clock => true) unless syncable.running?
        syncable.clock.pause
        @slave_queue.delete(syncable)
        updated << syncable
      end
      updated
    end
          
  end
  
end
