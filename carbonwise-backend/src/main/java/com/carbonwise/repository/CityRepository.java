package com.carbonwise.repository;

import com.carbonwise.entity.City;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CityRepository extends JpaRepository<City, String> {
}
