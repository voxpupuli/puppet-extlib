# @summary Expand list of "start-end" ranges into an array of numbers
# @param ranges
#   Either an Array of ranges, e.g. ["1-4", "8-9"] or a String with
#   comma-separated ranges list
# @return [Array[Integer[0]]]
#   The Array of integers (deduplicated and sorted).
#
# @example
#   extlib::ranges_to_array('1-4,8-9')       # => [1,2,3,4,8,9]
#   extlib::ranges_to_array(['1-4', '8-9'])  # => [1,2,3,4,8,9]
#   extlib::ranges_to_array(['5'])           # => [5]
function extlib::ranges_to_array(Variant[Array[String[1]], String[1]] $ranges) >> Array[Integer[0]] {
  $ranges_array = $ranges ? {
    String  => $ranges.split(','),
    default => $ranges,
  }
  $ranges_array.reduce([]) |$acc, $r| {
    $rs = $r.strip()
    case $rs {
      /^(\d+)-(\d+)$/: {
        $start = Integer($1)
        $end   = Integer($2)
        if $start > $end {
          fail("invalid range '${r}' (range start should be less than range end)")
        }
        $acc + Array(Integer[$start, $end])
      }
      /^\d+$/: {
        $acc + [Integer($rs)]
      }
      default: {
        fail("invalid range '${r}'")
      }
    }
  }.unique().sort()
}
