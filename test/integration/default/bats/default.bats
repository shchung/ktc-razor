# vim: set ft=ruby:

@test "tftp service running" {
 netstat -uan | grep :69
}

@test "mongodb service running" {
 netstat -tan | grep :27017
}

@test "razor api service running" {
 netstat -tan | grep :8026
}

@test "razor image service running" {
 netstat -tan | grep :8027
}
