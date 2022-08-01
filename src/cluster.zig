const std = @import("std");
const log = std.log.scoped(.cluster);

// todo x: 导入当前路径的配置文件, 这个文件, 其实是 zig 代码
const config = @import("tigerbeetle.conf");

// ----------------------------------------------------------------

// todo x: 集群
pub const Cluster = struct {
    id: u128,

    // TODO X: 集群节点
    nodes: [config.nodes.len]ClusterNode,

    pub fn init() !Cluster {
        var nodes: [config.nodes.len]ClusterNode = undefined;
        log.info("cluster_id={}", .{config.cluster_id});

        // todo x: 初始化集群节点列表
        inline for (config.nodes) |node, index| {
            nodes[index] = .{
                .id = node.id,
                .address = try std.net.Address.parseIp4(node.ip, node.port), // todo x: IPv4
            };
            log.info("node {}: address={}", .{
                nodes[index].id,
                nodes[index].address,
            });
        }
        return Cluster{
            .id = config.cluster_id,
            .nodes = nodes,
        };
    }

    pub fn deinit(self: *Cluster) void {}
};

pub const ClusterNode = struct {
    id: u128,
    address: std.net.Address,
};
