package org.formation.inventory.internal;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

public interface StockRepository extends JpaRepository<StockEntity, Long> {

    Optional<StockEntity> findByCoffeeId(Long coffeeId);
}
