# @summary Collapse non-negative integers into an array of "start-end" ranges
# @param numbers
#   The array of non-negative integers to collapse.
# @return [Array[String[1]]]
#   Array of ranges, e.g. ["1-4", "8-9"].
#
# @example
#   extlib::array_to_ranges([1,2,3,4,8,9])  # => ['1-4', '8-9']
#   extlib::array_to_ranges([5])            # => ['5']
#   extlib::array_to_ranges([3,1,2,1,5])    # => ['1-3', '5']
function extlib::array_to_ranges(Array[Integer[0]] $numbers) >> Array[String[1]] {
  $sorted = $numbers.unique().sort()
  if $sorted.length() < 1 {
    return []
  }

  # Group numbers by (value-index). For consecutive numbers it should be constant.
  $groups = $sorted.group_by |$i, $v| { $v - $i }

  $groups.values.map |$chunk| {
    $min = $chunk[0]
    $max = $chunk[-1]
    if $min == $max {
      String($min)
    } else {
      "${min}-${max}"
    }
  }
}
