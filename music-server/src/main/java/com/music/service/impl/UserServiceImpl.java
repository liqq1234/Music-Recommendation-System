package com.music.service.impl;

import cn.hutool.crypto.digest.BCrypt;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.music.common.Constants;
import com.music.entity.User;
import com.music.mapper.UserMapper;
import com.music.service.UserService;
import com.music.utils.JwtUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    @Autowired
    private JwtUtils jwtUtils;

    @Override
    public Map<String, Object> login(String username, String password) {
        User user = this.getOne(new LambdaQueryWrapper<User>().eq(User::getUsername, username));
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        if (!BCrypt.checkpw(password, user.getPassword())) {
            throw new RuntimeException("密码错误");
        }
        if (user.getStatus() == Constants.STATUS_DISABLED) {
            throw new RuntimeException("账号已被禁用");
        }
        String token = jwtUtils.generateToken(user.getId(), user.getUsername(), user.getRole());
        Map<String, Object> result = new HashMap<>();
        result.put("token", token);
        user.setPassword(null);
        result.put("user", user);
        return result;
    }

    @Override
    public void register(User user) {
        // 检查用户名是否已存在
        long count = this.count(new LambdaQueryWrapper<User>().eq(User::getUsername, user.getUsername()));
        if (count > 0) {
            throw new RuntimeException("用户名已存在");
        }
        // BCrypt加密密码
        user.setPassword(BCrypt.hashpw(user.getPassword()));
        if (user.getRole() == null) {
            user.setRole(Constants.ROLE_USER);
        }
        user.setStatus(Constants.STATUS_NORMAL);
        if (user.getNickname() == null || user.getNickname().isEmpty()) {
            user.setNickname(user.getUsername());
        }
        this.save(user);
    }

    @Override
    public User getUserInfo(Long userId) {
        User user = this.getById(userId);
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }

    @Override
    public void updateUserInfo(User user) {
        // 不允许修改密码和角色
        user.setPassword(null);
        user.setRole(null);
        this.updateById(user);
    }

    @Override
    public void updatePassword(Long userId, String oldPassword, String newPassword) {
        User user = this.getById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        if (!BCrypt.checkpw(oldPassword, user.getPassword())) {
            throw new RuntimeException("原密码错误");
        }
        User update = new User();
        update.setId(userId);
        update.setPassword(BCrypt.hashpw(newPassword));
        this.updateById(update);
    }

    @Override
    public IPage<User> pageList(int pageNum, int pageSize, String keyword, Integer role) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.and(w -> w.like(User::getUsername, keyword).or().like(User::getNickname, keyword));
        }
        if (role != null) {
            wrapper.eq(User::getRole, role);
        }
        wrapper.orderByDesc(User::getCreateTime);
        IPage<User> page = this.page(new Page<>(pageNum, pageSize), wrapper);
        // 隐藏密码
        page.getRecords().forEach(u -> u.setPassword(null));
        return page;
    }

    @Override
    public void updateStatus(Long userId, Integer status) {
        User user = new User();
        user.setId(userId);
        user.setStatus(status);
        this.updateById(user);
    }

    @Override
    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalUsers", this.count(new LambdaQueryWrapper<User>().eq(User::getRole, Constants.ROLE_USER)));
        stats.put("totalSingers", this.count(new LambdaQueryWrapper<User>().eq(User::getRole, Constants.ROLE_SINGER)));
        stats.put("totalAdmins", this.count(new LambdaQueryWrapper<User>().eq(User::getRole, Constants.ROLE_ADMIN)));
        stats.put("total", this.count());
        return stats;
    }
}
