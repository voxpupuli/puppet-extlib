# frozen_string_literal: true

require 'ipaddr'

module PuppetX
  class Extlib
    class CIDR
      attr_reader :ip

      def initialize(cidr)
        @ip = IPAddr.new(cidr)
        @first = @ip.to_range.first
        @last = @ip.to_range.last
        @single_address = (@ip.ipv4? && @ip.prefix == 32) || (@ip.ipv6? && @ip.prefix == 128)

        if (@ip.ipv4? && @ip.prefix.between?(31, 32)) || (@ip.ipv6? && @ip.prefix.between?(127, 128))
          @host_min = @first
          @host_max = @last
        else
          @host_min = IPAddr.new(@first.to_i + 1, @ip.family)
          @host_max = IPAddr.new(@last.to_i - 1, @ip.family)
        end
        @host_current = @first
      end

      def address
        @ip.to_s
      end

      def canonical
        "#{@ip.to_string}/#{@ip.prefix}"
      end

      def netmask
        @ip.inspect.gsub(%r{.*/(.*)>}, '\1')
      end

      # ipv4/ipv6
      def family
        @ip.inspect.split(':')[1].strip.downcase
      end

      def prefix_length
        @ip.prefix
      end

      def is_single_address
        @single_address
      end

      def is_link_local
        @ip.link_local?
      end

      def is_loopback
        @ip.loopback?
      end

      def is_private
        @ip.private?
      end

      def first
        @first.to_s
      end

      def last
        @last.to_s
      end

      # Total amount of addresses in the range
      def count
        @last.to_i - @first.to_i + 1
      end

      # Amount of usable addresses in the range (except first and last addresses)
      def host_count
        @host_max.to_i - @host_min.to_i + 1
      end

      def host_rewind(new_ip)
        raise ArgumentError, "IP should be between #{@first} and #{@last}" unless new_ip.between?(@first, @last)

        @host_current = IPAddr.new(new_ip)
        new_ip.to_s
      end

      def host_next
        host_next_by_step(1)
      end

      def host_prev
        host_next_by_step(-1)
      end

      # If our CIDR is just an IP address then just return next one.
      # Don't care about network range.
      def host_next_by_step(step = 1)
        next_ip = IPAddr.new(@host_current.to_i + step, @ip.family)

        if !@single_address
          if !next_ip.between?(@host_min, @host_max)
            return nil
          end
        end

        @host_current = next_ip
        return @host_current.to_s
      end

      def host_min
        @host_min.to_s
      end

      def host_max
        @host_max.to_s
      end

      def include?(other)
        if other.is_a? Extlib::CIDR
          @ip.include? other.ip
        else
          @ip.include? IPAddr.new(other)
        end
      end
      alias include include?

      def to_s
        if @single_address
          @ip.to_s
        else
          "#{@ip.to_s}/#{@ip.prefix}"
        end
      end

      def to_i
        @ip.to_i
      end

      # Compare IP addresses
      def <=>(other)
        @ip.to_i <=> if other.is_a? Extlib::CIDR
                       other.to_i
                     else
                       IPAddr.new(other).to_i
                     end
      end
      alias compare <=>
    end
  end
end
