package DAO;

import org.apache.commons.dbcp2.BasicDataSource;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DAO {
    private static BasicDataSource dataSource;
    private Connection connection;

    static {
        dataSource = new BasicDataSource();
        dataSource.setUsername("testuser");
        dataSource.setPassword("testuser");
        dataSource.setUrl("jdbc:mysql:///travels?serverTimezone=Asia/Shanghai");
    }

    public DAO() {

    }

    public void updateDatabase(String sql, Object... args) throws SQLException {
        PreparedStatement preparedStatement = getPreparedStatementWithArgs(sql, args);
        preparedStatement.executeUpdate();
        releaseDatabase(null, preparedStatement, connection);
    }

    public <T> T searchItem(String sql, Object... args) throws SQLException {
        PreparedStatement preparedStatement = getPreparedStatementWithArgs(sql, args);
        ResultSet resultSet = preparedStatement.executeQuery();
        T item = null;
        if (resultSet.next()) item = (T) resultSet.getObject(1);
        releaseDatabase(resultSet, preparedStatement, connection);
        return item;
    }

    public Map<String, Object> searchResult(String sql, Object... args) throws SQLException {
        PreparedStatement preparedStatement = getPreparedStatementWithArgs(sql, args);
        ResultSet resultSet = preparedStatement.executeQuery();
        ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
        Map<String, Object> result = new HashMap<>();
        if (resultSet.next()) {
            for (int i = 0; i < resultSetMetaData.getColumnCount(); i++) {
                String name = resultSetMetaData.getColumnName(i + 1);
                Object value = resultSet.getObject(i + 1);
                result.put(name, value);
            }
        }
        releaseDatabase(resultSet, preparedStatement, connection);
        return result;
    }

    public List<Map<String, Object>> searchResults(String sql, Object... args) throws SQLException {
        PreparedStatement preparedStatement = getPreparedStatementWithArgs(sql, args);
        ResultSet resultSet = preparedStatement.executeQuery();
        ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
        List<Map<String, Object>> results = new ArrayList<>();
        while (resultSet.next()) {
            Map<String, Object> result = new HashMap<>();
            for (int i = 0; i < resultSetMetaData.getColumnCount(); i++) {
                String name = resultSetMetaData.getColumnName(i + 1);
                Object value = resultSet.getObject(i + 1);
                result.put(name, value);
            }
            results.add(result);
        }
        releaseDatabase(resultSet, preparedStatement, connection);
        return results;
    }

    private PreparedStatement getPreparedStatementWithArgs(String sql, Object... args) throws SQLException {
        connection = dataSource.getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        for (int n = 0; n < args.length; n++) {
            preparedStatement.setObject(n + 1, args[n]);
        }
        return preparedStatement;
    }

    public Connection getConnection() {
        return connection;
    }

    private void releaseDatabase(ResultSet resultSet, Statement statement, Connection connection) {
        try {
            if (resultSet != null) resultSet.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            if (statement != null) statement.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            if (connection != null) connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
