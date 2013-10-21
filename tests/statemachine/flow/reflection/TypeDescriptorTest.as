package statemachine.flow.reflection
{
import org.hamcrest.assertThat;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.flow.impl.support.cmds.AsyncCmd;

public class TypeDescriptorTest
{
    private var _classUnderTest:TypeDescriptor;

    [Before]
    public function before()
    {
        _classUnderTest = new TypeDescriptor( new DescribeTypeReflector() );
    }


    [Test]
    public function describe_returns_instanceOf_TypeDescription():void
    {
        assertThat( _classUnderTest.describe( AsyncCmd ), instanceOf( TypeDescription ) );
    }

    [Test]
    public function describe_returns_cached_instanceOf_TypeDescription():void
    {
        const desc:TypeDescription = _classUnderTest.describe( AsyncCmd );
        assertThat( _classUnderTest.describe( AsyncCmd ), strictlyEqualTo( desc ) );
    }
}
}
