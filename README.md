A program that outputs a hierarchy tree based off of tuples (collections of two values) of names and the name of the person they report to. For instance, the tuple ["B" "A"] has the person B reporting to person A. Person A has ["A" nil] which means they report to no one (are at the top of the food chain). This data [["A" nil], ["B" "A"]] would be drawn as

A
└B

Following restrictions should be considered
1) The first entry will always be the root entry, i.e. the employee will have no one they report to.
2) There will only be one employee who reports to no one else in the tree.
3) The order will not be randomized.
