package org.formation.catalog;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/coffees")
class CatalogController {

    private final Catalog catalog;

    CatalogController(Catalog catalog) {
        this.catalog = catalog;
    }

    @PostMapping
    Long create(@RequestParam String name, @RequestParam int price) {
        return catalog.createCoffee(name, price);
    }

    @GetMapping
    List<Catalog.CoffeeView> all() {
        return catalog.findAll();
    }
}
