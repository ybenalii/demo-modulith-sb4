package org.formation.catalog;

import lombok.RequiredArgsConstructor;
import org.formation.catalog.internal.CoffeeEntity;
import org.formation.catalog.internal.CoffeeRepository;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class Catalog {

    private final CoffeeRepository repository;
    private final ApplicationEventPublisher events;

    @Transactional
    public Long createCoffee(String name, int price) {
        CoffeeEntity saved = repository.save(new CoffeeEntity(name, price));
        events.publishEvent(new CoffeeCreated(saved.getId(), saved.getName()));
        return saved.getId();
    }

    @Transactional(readOnly = true)
    public List<CoffeeView> findAll() {
        return repository.findAll().stream()
                .map(c -> new CoffeeView(c.getId(), c.getName(), c.getPrice()))
                .toList();
    }

    public record CoffeeView(Long id, String name, int price) {}
}
