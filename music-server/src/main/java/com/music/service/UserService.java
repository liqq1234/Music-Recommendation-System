package com.music.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.music.entity.User;

import java.util.Map;

public interface UserService extends IService<User> {

    Map<String, Object> login(String username, String password);

    void register(User user);

    User getUserInfo(Long userId);

    void updateUserInfo(User user);

    void updatePassword(Long userId, String oldPassword, String newPassword);

    IPage<User> pageList(int pageNum, int pageSize, String keyword, Integer role);

    void updateStatus(Long userId, Integer status);

    Map<String, Object> getStatistics();
}
