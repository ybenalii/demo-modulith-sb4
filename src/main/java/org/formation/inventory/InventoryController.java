package org.formation.inventory;

import org.formation.inventory.internal.StockEntity;
import org.formation.inventory.internal.StockRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("stocks")
class InventoryController {

    private final StockRepository repository;

    InventoryController(StockRepository repository) {
        this.repository = repository;
    }

    @GetMapping("/{coffeeId}")
    int quantity(@PathVariable Long coffeeId) {
        return repository.findByCoffeeId(coffeeId)
                .map(StockEntity::getQuantity)
                .orElse(0);
    }
}
