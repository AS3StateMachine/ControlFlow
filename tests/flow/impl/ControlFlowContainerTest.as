package flow.impl
{
import flow.dsl.ControlFlowMapping;
import flow.dsl.OptionalControlFlowMapping;
import flow.dsl.SimpleControlFlowMapping;
import flow.impl.support.ClassRegistry;
import flow.impl.support.mappings.MockOptionFlowGroup;
import flow.impl.support.mappings.MockSingleFlowGroup;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.core.not;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

public class ControlFlowContainerTest implements ClassRegistry
{
    private var _classUnderTest:ControlFlowContainer;
    private var _injector:Injector;
    private var _executables:Vector.<Class>;

    [Before]
    public function before():void
    {
        _executables = new Vector.<Class>();
        _injector = new Injector();
        _classUnderTest = new ControlFlowContainer( _injector );
        _injector.map( ControlFlowMapping ).toValue( _classUnderTest );
        _injector.map( ClassRegistry ).toValue( this );
        _injector.map( SimpleControlFlow ).toType( MockSingleFlowGroup );
        _injector.map( OptionalControlFlow ).toType( MockOptionFlowGroup );
    }

    [After]
    public function after():void
    {
        _executables = null;
        _classUnderTest = null;
        _injector.teardown();
        _injector = null;

    }


    [Test]
    public function constructor_creates_childInjector():void
    {
        assertThat( _classUnderTest.injector.parentInjector, strictlyEqualTo( _injector ) );
    }

    [Test]
    public function constructor_maps_ControlFlowMapping_to_self_in_childInjector():void
    {
        assertThat( _classUnderTest.injector.getInstance( ControlFlowMapping ), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function always_property_returns_instanceOf_SingleFlowMapping():void
    {
        assertThat( _classUnderTest.always, instanceOf( SimpleControlFlowMapping ) )
    }

    [Test]
    public function always_property_returns_unique_instanceOf_SingleFlowMapping():void
    {
        assertThat( _classUnderTest.always, not( _classUnderTest.always ) )
    }

    [Test]
    public function SingleFlowMapping_instance_added_to_groups():void
    {
        assertThat( _classUnderTest.always, strictlyEqualTo( _classUnderTest.blocks[0] ) )
    }

    [Test]
    public function either_property_returns_instanceOf_CaseFlowMapping():void
    {
        assertThat( _classUnderTest.either, instanceOf( OptionalControlFlowMapping ) )
    }

    [Test]
    public function either_property_returns_unique_instanceOf_CaseFlowMapping():void
    {
        assertThat( _classUnderTest.either, not( _classUnderTest.either ) )
    }

    [Test]
    public function CaseFlowMapping_instance_added_to_groups():void
    {
        assertThat( _classUnderTest.either, strictlyEqualTo( _classUnderTest.blocks[0] ) )
    }

    [Test]
    public function execute_iterates_through_executables():void
    {
        _classUnderTest
                .either
                .and.always
                .and.either;

        _classUnderTest.execute();

        assertThat( _executables.length, equalTo( 3 ) )
        assertThat(
                _executables
                , array(
                        strictlyEqualTo( MockOptionFlowGroup ),
                        strictlyEqualTo( MockSingleFlowGroup ),
                        strictlyEqualTo( MockOptionFlowGroup )
                ) );
    }


    public function register( c:Class ):void
    {
        _executables.push( c );
    }
}
}
